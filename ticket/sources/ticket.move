module ticket::ticket;

use std::string;

public struct Event has key{
    id: UID,
    event_name:string::String,
    sold_tickets:vector<ID>
}

public struct Ticket has key{
    id: UID,
    event_id: ID,
    ticket_number: u64,
    is_used: bool
}

public fun create_event (event_name: string::String, ctx:&mut TxContext){
    let event : Event = Event{
        id : object :: new(ctx),
        event_name : event_name,
        sold_tickets:vector::empty()
    };
    transfer::share_object(event);
}

public fun buy_ticket(event:&mut Event, ctx:&mut TxContext){
    let ticket : Ticket = Ticket{
        id:object::new(ctx),
        is_used:false,
        event_id:object::id(event),
        ticket_number:event.sold_tickets.length()
    };
    event.sold_tickets.push_back(object::id(&ticket));
    transfer::transfer(ticket, ctx.sender());
}

public fun use_ticket(ticket:&mut Ticket){
    ticket.is_used=true;
}

public fun delete_ticket(ticket: Ticket){
    let Ticket { id, event_id: _, ticket_number: _, is_used: _ } = ticket;
    object::delete(id);
}