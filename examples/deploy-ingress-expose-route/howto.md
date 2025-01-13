## Deploying ingress, route, expose

- Routes must include a "ct-router-type" label with values "public" or "private" (see [See Example](routes.yaml))
- Ingress must use "IngressClassName" with values "openshift-customer-public" or "openshift-customer-private" (see [See Example](ingresses.yaml))
- You can expose the nodeservice only on the private load balancer, balancing traffic between each node. Your NodePort must be within the range 30000–32767 (see [See Example](expose.yaml))
