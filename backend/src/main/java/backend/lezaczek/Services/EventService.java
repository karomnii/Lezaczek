package backend.lezaczek.Services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import backend.lezaczek.Helpers.JwtTokenHelper;
import backend.lezaczek.Model.Event;
import backend.lezaczek.Repositories.EventsRepository;
import jakarta.servlet.http.HttpServletRequest;

import java.sql.Date;
import java.util.List;
import java.util.Optional;

@Service
public class EventService {

    @Autowired
    JwtTokenHelper jwtTokenHelper;

    @Autowired
    private EventsRepository eventsRepository;

    public List<Event> getAllEvents() {
        return eventsRepository.findAll();
    }

    public Optional<Event> getEventById(Long id) {
        return eventsRepository.findById(id);
    }

    public List<Event> getEventsByDate(Date selectedDate, HttpServletRequest request) {
        //Long userId=Long.parseLong(jwtTokenHelper.extractClaims(request));
        Long userId=1L;
        return eventsRepository.findByDateUserId(selectedDate, userId.intValue());
    }

    public Event createEvent(Event event) {
        return eventsRepository.save(event);
    }

    public Event updateEvent(Long id, Event eventDetails, int userId) {
        Optional<Event> eventOptional = eventsRepository.findById(id);
        if (eventOptional.isPresent()) {
            Event event = eventOptional.get();
            if (event.getUserID() == userId) {
                event.setName(eventDetails.getName());
                event.setDescription(eventDetails.getDescription());
                event.setPlace(eventDetails.getPlace());
                event.setEventType(eventDetails.getEventType());
                event.setDateStart(eventDetails.getDateStart());
                event.setDateEnd(eventDetails.getDateEnd());
                event.setStartingTime(eventDetails.getStartingTime());
                event.setEndingTime(eventDetails.getEndingTime());
                return eventsRepository.save(event);
            } else {
                throw new RuntimeException("User not authorized to update this event");
            }
        } else {
            throw new RuntimeException("Event not found with id " + id);
        }
    }

    public void deleteEvent(Long id, int userId) {
        Optional<Event> eventOptional = eventsRepository.findById(id);
        if (eventOptional.isPresent()) {
            Event event = eventOptional.get();
            if (event.getUserID() == userId) {
                eventsRepository.deleteById(id);
            } else {
                throw new RuntimeException("User not authorized to delete this event");
            }
        } else {
            throw new RuntimeException("Event not found with id " + id);
        }
    }

    public boolean eventMatchesUser(Event event, HttpServletRequest request){
        //Long userId=Long.parseLong(jwtTokenHelper.extractClaims(request));
        Long userId=1L;
        if (event.getUserID() != userId) return false;
        return true;
    }
}
