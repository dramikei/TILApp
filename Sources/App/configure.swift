import FluentMySQL
import Vapor


public func configure(
    _ config: inout Config,
    _ env: inout Environment,
    _ services: inout Services
    ) throws {
    
    
    try services.register(FluentMySQLProvider())
    let router = EngineRouter.default()
    try routes(router)
    
    services.register(router, as: Router.self)
    var middlewares = MiddlewareConfig()
    middlewares.use(ErrorMiddleware.self)
    services.register(middlewares)
    
    
    var databases = DatabasesConfig()
    let databaseConfig = MySQLDatabaseConfig(
        hostname: "localhost",
        username: "vapor",
        password: "password",
        database: "vapor")
    
    
    let database = MySQLDatabase(config: databaseConfig)
    databases.add(database: database, as: .mysql)
    services.register(databases)
    var migrations = MigrationConfig()
    
    migrations.add(model: Acronym.self, database: .mysql)
    
    services.register(migrations)
}
