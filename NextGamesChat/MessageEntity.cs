using Microsoft.WindowsAzure.Storage.Table;

namespace NextGamesChat
{
    public class MessageEntity : TableEntity
    {
        public MessageEntity() { }

        public MessageEntity(string userName, string message)
        {
            this.PartitionKey = userName;
            this.RowKey = message;
        }
    }
}