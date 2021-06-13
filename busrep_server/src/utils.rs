use super::diesel::prelude::*;
use super::dotenv::dotenv;
use super::models::*;
use super::regex::Regex;
use std::env;

// Database
pub fn establish_connection() -> MysqlConnection {
    dotenv().ok();

    let database_url = env::var("DATABASE_URL").expect("DATABASE_URL must be set");
    MysqlConnection::establish(&database_url)
        .unwrap_or_else(|_| panic!("Error connecting to {}", database_url))
}

// Format check
pub fn check_post_format(req_post: &RequestPost) -> bool {
    if !check_key_format(&req_post.public_key) {
        return false;
    }
    if !check_key_format(&req_post.next_public_key) {
        return false;
    }
    if !check_ds_format(&req_post.digital_signature) {
        return false;
    }
    return true;
}

pub fn check_register_format(req_post: &RequestRegister) -> bool {
    if !check_key_format(&req_post.public_key) {
        return false;
    }
    if !check_key_format(&req_post.next_public_key) {
        return false;
    }
    if !check_ds_format(&req_post.digital_signature) {
        return false;
    }
    return true;
}

fn check_key_format(key: &String) -> bool {
    let re = Regex::new(r"\[\d{1,3}(,\d{1,3}){31}\]").unwrap();
    re.is_match(key)
}

fn check_ds_format(key: &String) -> bool {
    let re = Regex::new(r"\[\d{1,3}(,\d{1,3}){63}\]").unwrap();
    re.is_match(key)
}
