# Guide complet : Déployer avec Helmfile sur OpenShift

Ce guide explique comment déployer des applications sur notre PaaS OpenShift avec **Helmfile** en orchestrant plusieurs Helm charts ensemble.

---

## Objectifs

Ce tutoriel démontre :

- Déploiement d'un **front-end Nginx** avec routes publique et privée
- Déploiement d'un **back-end PostgreSQL** avec stockage persistant
- Utilisation de **charts Helm personnalisés**
- Respect des **contraintes et limitations connues**

---

## Contraintes et limitations connues

### Contraintes OpenShift

* Respecte les contraintes OpenShift  **(SCC restricted-V2)** appliqué automatiquement.
* Déploiement uniquement de **conteneurs sans privilèges**.
* **UIDs** assignés dynamiquement (> 30000).
* Capabilities droppées (`drop: ALL`).
* Ne jamais spécifier de `fsGroup` fixe (laisser OpenShift l'assigner).
* Aucun recours aux  **CRD personnalisés**.
* Pas d’accès au rôle de la plateforme en tant que  **cluster-admin**.
* Pas de déploiement au niveau du cluster (**installation cluster-wide**).
* Pas de **création de namespaces** via Helmfile (pour éviter des conflits de permissions).

### Labels Cloud Temple

- `ct-router-type: public` : Route accessible depuis Internet
- `ct-router-type: private` : Route accessible uniquement depuis le réseau interne

---

## Prérequis

- **OpenShift CLI (`oc`)** : [Installation](https://docs.openshift.com/container-platform/4.18/cli_reference/openshift_cli/getting-started-cli.html)
- **Helm** : [Installation](https://helm.sh/docs/intro/install/)
- **Helmfile** : [Installation](https://helmfile.readthedocs.io/en/latest/#installation)
- Cluster OpenShift géré par Cloud Temple
- Rôle **client admin**

---

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    Namespace: poc-helmfile                      │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌──────────────────┐           ┌──────────────────┐            │
│  │   Nginx Demo     │           │  Postgres Demo   │            │
│  │                  │           │                  │            │
│  │  - Deployment    │           │  - Deployment    │            │
│  │  - Service       │           │  - Service       │            │
│  │  - Route Public  │           │  - Secret        │            │
│  │  - Route Private │           │  - PVC (5Gi)     │            │
│  └──────────────────┘           └──────────────────┘            │
│         │                                │                      │
│         ├─ Public  (Internet)            │                      │
│         └─ Private (Interne)             ▼                      │
│                                   Stockage Ceph RBD             │
│                                   (ocs-storagecluster)          │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

**Composants déployés** :

- **Nginx** : Serveur web avec 2 routes (publique et privée)
- **PostgreSQL** : Base de données avec stockage persistant (PVC 5Gi)
- **Charts Helm personnalisés** : Contrôle total de la configuration
- **SCC restricted-v2** : Sécurité OpenShift respectée

---

## Prérequis

### Outils CLI

- **OpenShift CLI (`oc`)** : v4.20.8+
- **Helm** : v3.16.3+
- **Helmfile** : v1.3.2+

### Environnement

- Cluster OpenShift v4.18+ géré par Cloud Temple
- StorageClass `ocs-storagecluster-ceph-rbd` disponible
- Rôle **client admin** pour créer des projets

---

## Configuration

### Fichiers de configuration

Les fichiers de configuration sont disponibles dans le repository :

- **`helmfile.yaml`** : Orchestre le déploiement des deux applications
- **`values-nginx.yaml`** : Configuration Nginx (image, ressources)
- **`values-postgres.yaml`** : Configuration PostgreSQL (auth, storage, image)

**Points clés** :

- Charts locaux pour un contrôle total
- Fichiers de valeurs séparés par application
- Image nginx-unprivileged compatible SCC restricted-v2
- Image CloudNativePG PostgreSQL publique
- Stockage persistant sur Ceph RBD

---

## Déploiement

### 1. Connexion au cluster

```bash
oc login --server=https://api-ocp01-xxx.paas.cloud-temple.com:6443 --web
```

### 2. Créer le namespace

```bash
oc new-project poc-helmfile
```

### 3. Déployer avec Helmfile

```bash
cd examples/deploy-through-helmfile
helmfile sync
```

**Sortie attendue** :

```
Building dependency release=nginx-demo, chart=charts/nginx-demo
Building dependency release=postgres-demo, chart=charts/postgres-demo
Upgrading release=nginx-demo, chart=charts/nginx-demo, namespace=poc-helmfile
Upgrading release=postgres-demo, chart=charts/postgres-demo, namespace=poc-helmfile

UPDATED RELEASES:
NAME            NAMESPACE      CHART                  VERSION   DURATION
nginx-demo      poc-helmfile   charts/nginx-demo      1.0.0           1s
postgres-demo   poc-helmfile   charts/postgres-demo   1.0.0           1s
```

---

## Vérification

### Vérifier les pods

```bash
oc get pods -n poc-helmfile
```

**Sortie attendue** :

```
NAME                             READY   STATUS    RESTARTS   AGE
nginx-demo-xxx                   1/1     Running   0          30s
postgres-demo-xxx                1/1     Running   0          30s
```

### Vérifier les routes

```bash
oc get routes -n poc-helmfile
```

**Sortie attendue** :

```
NAME                  HOST/PORT                                    PORT   TERMINATION
nginx-demo-public     nginx-demo-public-poc-helmfile.apps...      8080   edge
nginx-demo-private    nginx-demo-private-poc-helmfile.apps...     8080   edge
```

**Deux routes créées** :

- **Route publique** : Accessible depuis Internet
- **Route privée** : Accessible uniquement depuis le réseau interne

### Vérifier le PVC

```bash
oc get pvc -n poc-helmfile
```

**Sortie attendue** :

```
NAME                STATUS   VOLUME      CAPACITY   STORAGECLASS
postgres-demo-pvc   Bound    pvc-xxx     5Gi        ocs-storagecluster-ceph-rbd
```

### Vérifier le SCC

```bash
oc get pod -n poc-helmfile -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.metadata.annotations.openshift\.io/scc}{"\n"}{end}'
```

**Sortie attendue** :

```
nginx-demo-xxx        restricted-v2
postgres-demo-xxx     restricted-v2
```

> **Note** : Les UIDs sont automatiquement assignés par OpenShift (> 30000) conformément au SCC restricted-v2.

---

## Tests

### Tester Nginx (route publique)

```bash
# Obtenir l'URL
echo "URL : https://$(oc get route nginx-demo-public -n poc-helmfile -o jsonpath='{.spec.host}')"

# Tester
curl -k "https://$(oc get route nginx-demo-public -n poc-helmfile -o jsonpath='{.spec.host}')"
```

**Résultat attendu** : Page d'accueil Nginx par défaut

### Tester Nginx (route privée)

```bash
# Obtenir l'URL
echo "URL : https://$(oc get route nginx-demo-private -n poc-helmfile -o jsonpath='{.spec.host}')"
```

**Résultat attendu** : Accessible uniquement depuis le réseau interne Cloud Temple

### Tester PostgreSQL avec le Job

```bash
# Lancer le Job de test
oc apply -f test-postgres-job.yaml

# Attendre la fin
oc wait --for=condition=complete job/postgres-test -n poc-helmfile --timeout=60s

# Voir les résultats
oc logs job/postgres-test -n poc-helmfile
```

**Le Job effectue 10 tests** :

1. Connexion PostgreSQL
2. Création de table
3. Insertion de données
4. Lecture de données
5. Requêtes SQL complexes (agrégations)
6. Vérification de la persistance
7. Statistiques de la base
8. Vérification du stockage PVC
9. Mise à jour de données
10. Vérification des mises à jour

**Sortie attendue** :

```
==========================================
  TEST POC PostgreSQL - Validation complète
==========================================

1. Test de connexion à PostgreSQL...
 Connexion réussie !

[...]

10. Vérification des données mises à jour...
 id |  nom   | valeur
----+--------+--------
  1 | Test 1 |    200
  2 | Test 2 |    400
  3 | Test 3 |    600

==========================================
   VALIDATION POC RÉUSSIE !
==========================================
```

---

## Validation

### Checklist de validation

**Déploiement**

- [ ] Les deux pods sont en état `Running`
- [ ] Les 2 routes Nginx sont créées (publique + privée)
- [ ] Le PVC PostgreSQL est en état `Bound`

**Sécurité**

- [ ] SCC `restricted-v2` appliqué aux deux pods
- [ ] UIDs > 30000 (assignés automatiquement)
- [ ] Aucun privilège root utilisé

**Fonctionnalité**

- [ ] Nginx accessible via route publique (HTTPS)
- [ ] Nginx accessible via route privée (réseau interne)
- [ ] PostgreSQL démarre sans erreur
- [ ] Job de test PostgreSQL réussit (10/10 tests)

---

## Nettoyage

```bash
# Supprimer les releases Helmfile
helmfile destroy

# Ou supprimer le namespace complet
oc delete project poc-helmfile
```

---

## Ressources supplémentaires

- [Documentation Helmfile](https://helmfile.readthedocs.io/)
- [Documentation Helm](https://helm.sh/docs/)
- [OpenShift SCC Documentation](https://docs.openshift.com/container-platform/4.18/authentication/managing-security-context-constraints.html)
- [CloudNativePG PostgreSQL Containers](https://github.com/cloudnative-pg/postgres-containers)
- [Cloud Temple OpenShift Documentation](https://docs.cloud-temple.com/paas_openshift/)
