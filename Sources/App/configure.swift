import FluentPostgreSQL
import Vapor

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    // Register providers first
    try services.register(FluentPostgreSQLProvider())

    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    // Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    // middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)

    // Register the configured SQLite database to the database config.
    var databases = DatabasesConfig()
    let config = PostgreSQLDatabaseConfig(hostname: "localhost", username: "raphaelcarletti", database: "blackbird")
    databases.add(database: PostgreSQLDatabase(config: config), as: .psql)
    services.register(databases)

    // Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: AppUser.self, database: .psql)
    migrations.add(model: UserFollowersPivot.self, database: .psql)
    migrations.add(model: Tweet.self, database: .psql)
    services.register(migrations)
}
