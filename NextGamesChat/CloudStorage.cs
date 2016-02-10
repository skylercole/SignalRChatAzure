using System.Configuration;
using Microsoft.AspNet.SignalR.Hubs;
using Microsoft.WindowsAzure.Storage;
using Microsoft.WindowsAzure.Storage.Table;

namespace NextGamesChat
{
    public class CloudStorage : IChatRepository
    {
        private static CloudTable _table;

        public CloudStorage(IHubConnectionContext<dynamic> clients)
        {
            if (_table == null)
                Connect();
        }

        public void Connect()
        {
            // Fetch the connection string from web.config.
            var storageAccount = CloudStorageAccount.Parse(
                ConfigurationManager.ConnectionStrings["StorageConnectionString"].ConnectionString);

            // Create the table client.
            var tableClient = storageAccount.CreateCloudTableClient();

            // Create the CloudTable object that represents the "messages" table.
            _table = tableClient.GetTableReference("messages");
            _table.CreateIfNotExists();
        }

        public void Add(string name, string message)
        {
            try
            {
                // Create the message entity to be stored in cloud table.
                var messageEntity = new MessageEntity(name, message); // Do not use backslash in PartitionKey, you will get HTTP 400.

                // Create the TableOperation object that inserts the customer entity.
                var insertOperation = TableOperation.Insert(messageEntity);

                // Execute the insert operation.
                _table.Execute(insertOperation);
            }
            catch
            {
                // Logging not implemented.
            }
        }
    }
}