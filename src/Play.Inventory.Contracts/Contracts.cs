namespace Play.Inventory.Contracts
{
    //Correlation Id is what the state machine uses to correlate the different messages that belong to 
    //one specific instance of the state machine.

    // Without the correlationId, the state machine will not know how to map the messages to the 
    // different instances of the state machine that could be hapening at any given time.
    // All messages that belong to one specific transaction should have the same correlationId
    public record GrantItems(Guid UserId, Guid CatalogItemId, int Quantity, Guid CorrelationId);

    public record InventoryItemsGranted(Guid CorrelationId);

    public record SubtractItems(Guid UserId, Guid CatalogItemId, int Quantity, Guid CorrelationId);

    public record InventoryItemsSubtracted(Guid CorrelationId);

    public record InventoryItemUpdated(Guid UserId, Guid CatalogItemId, int NewTotalQuantity);


}
