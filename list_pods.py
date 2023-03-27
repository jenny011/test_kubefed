from kubernetes import client, config
from kubernetes.client import configuration
# https://stackoverflow.com/questions/65366350/what-is-the-kubernetes-api-equivalent-of-context

if __name__ == "__main__":
	contexts, active_context = config.list_kube_config_contexts()
	contexts = [context['name'] for context in contexts]
	print(contexts)
	active_index = contexts.index(active_context['name'])
	print("active", active_index)

	# cluster1, first_index = pick(contexts, title="Pick the first context", default_index=active_index)
	# cluster2, _ = pick(contexts, title="Pick the second context", default_index=first_index)

	client1 = client.CoreV1Api(api_client=config.new_client_from_config(context=contexts[0]))
	client2 = client.CoreV1Api(api_client=config.new_client_from_config(context=contexts[1]))

	print("\nList of pods on %s:" % contexts[0])
	for i in client1.list_pod_for_all_namespaces().items:
		print("%s\t%s\t%s" % (i.status.pod_ip, i.metadata.namespace, i.metadata.name))

	print("\n\nList of pods on %s:" % contexts[1])
	for i in client2.list_pod_for_all_namespaces().items:
		print("%s\t%s\t%s" % (i.status.pod_ip, i.metadata.namespace, i.metadata.name))

