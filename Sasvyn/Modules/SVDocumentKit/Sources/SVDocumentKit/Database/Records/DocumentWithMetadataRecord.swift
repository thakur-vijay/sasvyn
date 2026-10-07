struct DocumentWithMetadataRecord: Codable, FetchableRecord {

    let documentID: String
    let documentName: String
    let documentPath: String
    let documentCategory: String
    let documentFileSize: Int64
    let documentCreatedAt: Date
    let documentUpdatedAt: Date

    let metadataID: String?
    let entityType: String?
    let entityID: String?
    let syncStatus: SyncStatus?
    let serverVersion: Int64?
    let syncedAt: Date?
    let syncOperationID: String?
    let syncOperation: String?
    let syncRetryCount: Int?
    let syncError: String?

    enum CodingKeys: String, CodingKey {
        case documentID = "document_id"
        case documentName = "document_name"
        case documentPath = "document_path"
        case documentCategory = "document_category"
        case documentFileSize = "document_file_size"
        case documentCreatedAt = "document_created_at"
        case documentUpdatedAt = "document_updated_at"

        case metadataID = "metadata_id"
        case entityType = "entity_type"
        case entityID = "entity_id"
        case syncStatus = "sync_status"
        case serverVersion = "server_version"
        case syncedAt = "synced_at"
        case syncOperationID = "sync_operation_id"
        case syncOperation = "sync_operation"
        case syncRetryCount = "sync_retry_count"
        case syncError = "sync_error"
    }
}