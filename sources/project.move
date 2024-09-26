module RentalAgreement::Rental {

    use aptos_framework::timestamp;
    use std::signer;

    struct Rental has key {
        owner: address,
        renter: address,
        asset_id: vector<u8>,
        start_time: u64,
        duration: u64,
        is_active: bool,
    }

    /// Create a new rental agreement
    public fun create_rental(
        owner: &signer,
        renter: address,
        asset_id: vector<u8>,
        duration: u64
    ) {
        let agreement = Rental {
            owner: signer::address_of(owner),
            renter,
            asset_id,
            start_time: timestamp::now_seconds(),
            duration,
            is_active: true,
        };
        move_to(owner, agreement);
    }

    /// Execute the rental agreement based on time condition
    public fun execute_rental(owner: &signer) acquires Rental {
        let rental = borrow_global_mut<Rental>(signer::address_of(owner));
        let current_time = timestamp::now_seconds();
        let end_time = rental.start_time + rental.duration;
        assert!(rental.is_active && current_time <= end_time, 101);
        rental.is_active = false;
    }
}
