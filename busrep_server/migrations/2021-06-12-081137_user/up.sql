-- Your SQL goes here
create table user (
    user_id varchar(36) primary key,
    username text not null,
    public_key text not null,
    next_public_key text not null
    )