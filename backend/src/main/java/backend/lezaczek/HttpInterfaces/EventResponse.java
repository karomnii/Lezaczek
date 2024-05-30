package backend.lezaczek.HttpInterfaces;

import lombok.Getter;
import lombok.ToString;

import java.util.List;

import backend.lezaczek.Model.Event;
@ToString
public class EventResponse extends Response{
    @Getter
    private final List<Event> events;

    public EventResponse(List<Event> response) {
        super("ok");
        this.events = response;
    }

}