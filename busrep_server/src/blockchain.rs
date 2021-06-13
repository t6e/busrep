use super::chrono::Local;
use super::crypto::digest::Digest;
use super::crypto::sha2::Sha256;
use super::models::*;

pub fn created() -> String {
    format!("{}", Local::now().naive_local())
}

pub fn previous_hash(block: Block) -> String {
    let mut hasher = Sha256::new();
    hasher.input_str(&format!(
        "{id}{action}{action_id}{ds}{created}{previous_hash}",
        id = block.block_id,
        action = block.action,
        action_id = block.action_id,
        ds = block.digital_signature,
        created = block.created,
        previous_hash = block.previous_hash
    ));
    hasher.result_str()
}
