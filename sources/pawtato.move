module new_nft::pawtato;

use sui::url::{Self, Url};
use sui::vec_map::{Self, VecMap};
use sui::package;
use sui::display;

use std::string::{Self, String};

public struct PAWTATO has drop {}

public struct LAND has store, key {
    id: UID,
    name: String,
    description: String,
    image_url: Url,
    attributes: VecMap<String, String>,
}

fun init(otw: PAWTATO, ctx: &mut TxContext) {
    let land = LAND {
        id          : object::new(ctx),
        name        : string::utf8(b"Pawtato Land"),
        description : string::utf8(x"5375692773206669727374207669727475616c206c616e6420636f6c6c656374696f6e2068617320617272697665642e204163726f73732061206e657720776f726c642c20756e6971756520706c6f747320617761697420e2809420756e746f756368656420616e642066756c6c206f6620706f74656e7469616c2e20536f6d652077696c6c206275696c642c20736f6d652077696c6c2063726166742c206f74686572732077696c6c20666f726765207468656972206f776e20706174682e205468652073746f7279206973206a75737420626567696e6e696e672c20616e6420697420737461727473207769746820796f7572206c616e642e"),
        image_url   : url::new_unsafe_from_bytes(*string::as_bytes(&string::utf8(b"https://img.pawtato.app/land/16464.png"))),
        attributes  : vec_map::empty<String, String>(),
    };

    let keys = vector[
        b"name".to_string(),
        b"link".to_string(),
        b"image_url".to_string(),
        b"description".to_string(),
        b"project_url".to_string(),
        b"creator".to_string(),
    ];

    let values = vector[
        // For `name` one can use the `Hero.name` property
        b"Pawtato Land".to_string(),
        // For `link` one can build a URL using an `id` property
        b"https://land.pawtato.app".to_string(),
        // For `image_url` use an IPFS template + `image_url` property.
        b"https://img.pawtato.app/land/16464.png".to_string(),
        // Description is static for all `Hero` objects.
        b"Pawtato Land is a blockchain based roleplaying strategy game where land owners can shape the world players are interacting with.".to_string(),
        // Project URL is usually static
        b"https://land.pawtato.app/".to_string(),
        // Creator field can be any
        b"Dave".to_string(),
    ];

    let publisher = package::claim(otw, ctx);

    let mut display = display::new_with_fields<LAND>(
        &publisher, keys, values, ctx
    );
    display.update_version();

    transfer::public_transfer(publisher, ctx.sender());
    transfer::public_transfer(display, ctx.sender());
    transfer::public_transfer(land, tx_context::sender(ctx))
}
