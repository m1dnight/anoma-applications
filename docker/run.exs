eclient = Anoma.Client.Examples.EClient.create_example_client()
Logger.configure(level: :debug)
Anoma.Node.Utility.Consensus.start_link(node_id: eclient.node.node_id, interval: 500)
