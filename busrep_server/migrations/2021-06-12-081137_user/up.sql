-- Your SQL goes here
create table user (
    id serial primary key,
    user_id varchar(36) not null,
    username text not null,
    public_key text not null,
    next_public_key text not null
    )