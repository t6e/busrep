use super::schema::{blockchain, post, user};
use super::serde::{Deserialize, Serialize};

#[derive(Queryable, Serialize)]
pub struct Block {
    pub block_id: u64,
    pub action: String,
    pub action_id: u64,
    pub digital_signature: String,
    pub created: String,
    pub previous_hash: String,
}

#[derive(Insertable)]
#[table_name = "blockchain"]
pub struct NewBlock<'a> {
    pub action: &'a str,
    pub action_id: &'a u64,
    pub digital_signature: &'a str,
    pub created: &'a str,
    pub previous_hash: &'a str,
}

#[derive(Serialize)]
pub struct ResponseBlockchain {
    pub blockchain: Vec<Block>,
}

#[derive(Queryable, Serialize)]
pub struct Post {
    pub post_id: u64,
    pub content: String,
    pub public_key: String,
    pub next_public_key: String,
}

#[derive(Deserialize)]
pub struct RequestPost {
    pub content: String,
    pub public_key: String,
    pub next_public_key: String,
    pub digital_signature: String,
    pub max_block_id: u64,
}

#[derive(Insertable)]
#[table_name = "post"]
pub struct NewPost<'a> {
    pub content: &'a str,
    pub public_key: &'a str,
    pub next_public_key: &'a str,
}

#[derive(Deserialize)]
pub struct RequestRegister {
    pub user_id: String,
    pub username: String,
    pub public_key: String,
    pub next_public_key: String,
    pub digital_signature: String,
}

#[derive(Queryable, Serialize)]
pub struct User {
    pub id: u64,
    pub user_id: String,
    pub username: String,
    pub public_key: String,
    pub next_public_key: String,
}

#[derive(Insertable)]
#[table_name = "user"]
pub struct NewUser<'a> {
    pub user_id: &'a str,
    pub username: &'a str,
    pub public_key: &'a str,
    pub next_public_key: &'a str,
}

#[derive(Deserialize)]
pub struct RequestUpdate {
    pub max_block_id: u64,
}

#[derive(Deserialize)]
pub struct RequestView {
    pub user: Vec<u64>,
    pub post: Vec<u64>,
}

#[derive(Serialize)]
pub struct ResponseView {
    pub user: Vec<User>,
    pub post: Vec<Post>,
}

#[derive(Serialize)]
pub struct ResponseUserIDList {
    pub user_id_list: Vec<String>,
}
