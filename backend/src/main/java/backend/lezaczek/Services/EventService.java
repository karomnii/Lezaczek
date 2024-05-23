package backend.lezaczek.Services;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Service;

import backend.lezaczek.Model.Event;
import backend.lezaczek.Repositories.EventsRepository;

@Service
public class EventService {
    @Autowired
    private EventsRepository eventsRepository;
    @Query(value = "SELECT * FROM Events", nativeQuery = true)
    public List<Event> getAllEvents() {
        return eventsRepository.findAll();
    }
    public Event saveUser(Event event) {
        return eventsRepository.save(event);
    }
}
