#[macro_use]
extern crate diesel;
extern crate actix_web;
extern crate chrono;
extern crate crypto;
extern crate dotenv;
extern crate regex;
extern crate serde;

pub mod api;
pub mod blockchain;
pub mod models;
pub mod operation;
pub mod schema;
pub mod utils;

use self::api::{post, update, user_id_list};

use actix_web::{web, App, HttpServer};

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    HttpServer::new(|| {
        App::new()
            .route("/post", web::post().to(post))
            // .route("/view", web::post().to(view))
            // .route("/register", web::post().to(register))
            .route("/update", web::post().to(update))
            .route("/user_id_list", web::get().to(user_id_list))
    })
    .bind("0.0.0.0:8088")?
    .run()
    .await
}
