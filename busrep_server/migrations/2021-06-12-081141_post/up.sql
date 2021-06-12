-- Your SQL goes here
create table post (
    post_id serial primary key,
    content text not null,
    public_key text not null,
    next_public_key text not null
    )