use super::models::*;
use super::operation::*;
use super::utils::*;
use actix_web::{web, HttpResponse, Responder};

pub async fn post(req_post: web::Json<RequestPost>) -> impl Responder {
    let connection = establish_connection();

    if !check_post_format(&req_post) {
        panic!("Incorrect Format");
    }

    let post = save_post(&connection, &req_post);
    save_post_blockchain(&connection, post, &req_post);
    let recent_blockchain = get_blockchain_above_id(&connection, &req_post.max_block_id);
    HttpResponse::Ok().json(ResponseBlockchain {
        blockchain: recent_blockchain,
    })
}

pub async fn register(req_register: web::Json<RequestRegister>) -> impl Responder {
    let connection = establish_connection();
    println!(
        "{}",
        format!(
            "{digital_signature}",
            digital_signature = req_register.digital_signature,
        )
    );
    // println!(
    //     "{}",
    //     format!(
    //         "{user_id}{username}{public_key}{next_public_key}{digital_signature}",
    //         user_id = req_register.user_id,
    //         username = req_register.username,
    //         public_key = req_register.public_key,
    //         next_public_key = req_register.next_public_key,
    //         digital_signature = req_register.digital_signature,
    //     )
    // );

    if !check_register_format(&req_register) {
        panic!("Incorrect Format");
    }

    let user = save_user(&connection, &req_register);
    save_register_blockchain(&connection, user, &req_register);
    let full_blockchain = get_full_blockchain(&connection);
    HttpResponse::Ok().json(ResponseBlockchain {
        blockchain: full_blockchain,
    })
}

pub async fn view<'a>(req_view: web::Json<RequestView>) -> impl Responder {
    let connection = establish_connection();
    let user = get_user_by_id(&connection, &req_view);
    let post = get_post_by_id(&connection, &req_view);

    HttpResponse::Ok().json(ResponseView {
        user: user,
        post: post,
    })
}

pub async fn update(req_update: web::Json<RequestUpdate>) -> impl Responder {
    let connection = establish_connection();

    let recent_blockchain = get_blockchain_above_id(&connection, &req_update.max_block_id);
    HttpResponse::Ok().json(ResponseBlockchain {
        blockchain: recent_blockchain,
    })
}

pub async fn user_id_list() -> impl Responder {
    let connection = establish_connection();

    let user_id_list = get_user_id_list(&connection);
    HttpResponse::Ok().json(ResponseUserIDList {
        user_id_list: user_id_list,
    })
}
