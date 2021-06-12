-- Your SQL goes here
create table blockchain (
    block_id serial primary key,
    action text not null,
    action_id bigint unsigned not null,
    digital_signature text not null,
    created text not null,
    previous_hash text not null
    )