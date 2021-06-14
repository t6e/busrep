use super::blockchain::*;
use super::diesel::prelude::*;
use super::models::*;

pub fn save_post(conn: &MysqlConnection, req_post: &RequestPost) -> Post {
    use crate::schema::post;

    let new_post = NewPost {
        content: &req_post.content,
        public_key: &req_post.public_key,
        next_public_key: &req_post.next_public_key,
    };

    diesel::insert_into(post::table)
        .values(&new_post)
        .execute(conn)
        .expect("Error saving post");

    post::table.order(post::post_id.desc()).first(conn).unwrap()
}

pub fn save_user(conn: &MysqlConnection, req_register: &RequestRegister) -> User {
    use crate::schema::user;

    let new_user = NewUser {
        user_id: &req_register.user_id,
        username: &req_register.username,
        public_key: &req_register.public_key,
        next_public_key: &req_register.next_public_key,
    };

    diesel::insert_into(user::table)
        .values(&new_user)
        .execute(conn)
        .expect("Error saving post");

    user::table.order(user::id.desc()).first(conn).unwrap()
}

pub fn save_post_blockchain(conn: &MysqlConnection, post: Post, req_post: &RequestPost) {
    use crate::schema::blockchain;

    let created = created();
    let previous_hash = match last_block(conn) {
        Some(last_block) => previous_hash(last_block),
        None => {
            panic!("Impossible");
        }
    };

    let new_block = NewBlock {
        action: "Post",
        action_id: &post.post_id,
        digital_signature: &req_post.digital_signature,
        created: &created,
        previous_hash: &previous_hash,
    };

    diesel::insert_into(blockchain::table)
        .values(&new_block)
        .execute(conn)
        .expect("Error saving blockchain");
}

pub fn save_register_blockchain(
    conn: &MysqlConnection,
    user: User,
    req_register: &RequestRegister,
) {
    use crate::schema::blockchain;

    let created = created();
    let previous_hash = match last_block(conn) {
        Some(last_block) => previous_hash(last_block),
        None => "GENESIS BLOCK".to_string(),
    };

    let new_block = NewBlock {
        action: "Register",
        action_id: &user.id,
        digital_signature: &req_register.digital_signature,
        created: &created,
        previous_hash: &previous_hash,
    };

    diesel::insert_into(blockchain::table)
        .values(&new_block)
        .execute(conn)
        .expect("Error saving blockchain");
}

pub fn last_block(conn: &MysqlConnection) -> Option<Block> {
    use crate::schema::blockchain;
    match blockchain::table
        .order(blockchain::block_id.desc())
        .first(conn)
    {
        Ok(x) => Some(x),
        Err(_) => None,
    }
}

pub fn get_blockchain_above_id(conn: &MysqlConnection, max_block_id: &u64) -> Vec<Block> {
    use crate::schema::blockchain::dsl::*;
    blockchain
        .filter(block_id.gt(max_block_id))
        .load::<Block>(conn)
        .expect("Error get block above id")
}

pub fn get_full_blockchain(conn: &MysqlConnection) -> Vec<Block> {
    use crate::schema::blockchain::dsl::*;
    match blockchain.load::<Block>(conn) {
        Ok(x) => x,
        Err(_) => Vec::new(),
    }
}

pub fn get_user_by_id(conn: &MysqlConnection, req_view: &RequestView) -> Vec<User> {
    use crate::schema::user::dsl::*;
    match user
        .filter(crate::schema::user::dsl::id.eq_any(&req_view.user))
        .load::<User>(conn)
    {
        Ok(x) => x,
        Err(_) => Vec::new(),
    }
}

pub fn get_post_by_id(conn: &MysqlConnection, req_view: &RequestView) -> Vec<Post> {
    use crate::schema::post::dsl::*;
    match post
        .filter(crate::schema::post::dsl::post_id.eq_any(&req_view.post))
        .load::<Post>(conn)
    {
        Ok(x) => x,
        Err(_) => Vec::new(),
    }
}

pub fn get_user_id_list(conn: &MysqlConnection) -> Vec<String> {
    use crate::schema::user::dsl::*;
    match user.select(user_id).load::<String>(conn) {
        Ok(x) => x,
        Err(_) => Vec::new(),
    }
}
