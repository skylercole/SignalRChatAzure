using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.AspNet.SignalR;

namespace NextGamesChat
{
    public class ChatHub : Hub
    {
        static private Dictionary<string, string> _connectedUsers = new Dictionary<string, string>();
        private IChatRepository _repository;

        public ChatHub(IChatRepository repository)
        {
            _repository = repository;
        }

        // Broadcast message to all clients. Called by client.
        public void Send(string name, string message)
        {
            // Persist chat message.
            _repository.Add(Context.ConnectionId + @" : " + name, message);

            // Call the broadcastMessage method to update clients.
            Clients.All.broadcastMessage(name, message);
        }

        // Assign an user name to connection id. Connection id will already be created in OnConnected(). Called by client.
        public void AssignName(string name)
        {
            var id = Context.ConnectionId;

            if (!_connectedUsers.ContainsKey(id))
            { 
                _connectedUsers.Add(id, name);
            }
            else
            {
                _connectedUsers[id] = name;
            }

            Clients.All.showConnected(_connectedUsers);
        }

        // Add new connection id when new user connects.
        public override Task OnConnected()
        {
            var id = Context.ConnectionId;

            if (!_connectedUsers.ContainsKey(id))
                _connectedUsers.Add(id, "");

            return base.OnConnected();
        }

        // Add new connection id when user reconnects.
        public override Task OnReconnected()
        {
            var id = Context.ConnectionId;

            if (!_connectedUsers.ContainsKey(id))
                _connectedUsers.Add(id, "");

            return base.OnConnected();
        }

        // Remove connection id when user disconnects.
        public override Task OnDisconnected(bool stopCalled)
        {
            var id = Context.ConnectionId;

            if (_connectedUsers.ContainsKey(id))
                _connectedUsers.Remove(id);

            Clients.All.showConnected(_connectedUsers);

            return base.OnConnected();
        }
    }
}