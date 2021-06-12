table! {
    blockchain (block_id) {
        block_id -> Unsigned<Bigint>,
        action -> Text,
        action_id -> Unsigned<Bigint>,
        digital_signature -> Text,
        created -> Text,
        previous_hash -> Text,
    }
}

table! {
    post (post_id) {
        post_id -> Unsigned<Bigint>,
        content -> Text,
        public_key -> Text,
        next_public_key -> Text,
    }
}

table! {
    user (user_id) {
        user_id -> Varchar,
        username -> Text,
        public_key -> Text,
        next_public_key -> Text,
    }
}

allow_tables_to_appear_in_same_query!(
    blockchain,
    post,
    user,
);
