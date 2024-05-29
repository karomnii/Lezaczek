package backend.lezaczek.Services;

import org.springframework.beans.factory.annotation.Autowired;
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
        try {
            // Long userId = 1L; // hardcoded for testing
            Long userId = Long.parseLong(jwtTokenHelper.extractUserId(request));
            return eventsRepository.findByDateUserId(selectedDate, userId.intValue());
        } catch (Throwable e) {
            throw new RuntimeException("Authorization token invalid");
        }
    }
    
    public Event createEvent(Event event) {
        return eventsRepository.save(event);
    }

    public Event updateEvent(Event eventDetails) {
        Optional<Event> eventOptional = eventsRepository.findById(Long.valueOf(eventDetails.getEventId()));
        if (eventOptional.isPresent()) {
            Event event = eventOptional.get();
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
            throw new RuntimeException("Event not found");
        }
    }

    public void deleteEvent(Long id, HttpServletRequest request) {
        Optional<Event> eventOptional = eventsRepository.findById(id);
        if (eventOptional.isPresent()) {
            Event event = eventOptional.get();
            try {
                // Long userId = 1L; // hardcoded for testing
                Long userId = Long.parseLong(jwtTokenHelper.extractUserId(request));
                if (event.getUserID() == userId) {
                    eventsRepository.deleteById(id);
                } else {
                    throw new RuntimeException("User not authorized to delete this event");
                }
            } catch (Throwable e) {
                throw new RuntimeException("Authorization token invalid");
            }
        } else {
            throw new RuntimeException("Event not found");
        }
    }

    public boolean eventMatchesUser(Event event, HttpServletRequest request){
        try {
            // Long userId = 1L; // hardcoded for testing
            Long userId = Long.parseLong(jwtTokenHelper.extractUserId(request));
            if (event.getUserID() != userId) return false;
        } catch (Throwable e) {
            return false;
        }
        return true;
    }

    public boolean eventIdMatchesUser(Long eventId, HttpServletRequest request){
        Optional<Event> eventOpt = eventsRepository.findById(eventId);
        if (eventOpt.isEmpty()) return false;
        Event event = eventOpt.get();
        try {
            // Long userId = 1L; // hardcoded for testing
            Long userId = Long.parseLong(jwtTokenHelper.extractUserId(request));
            if (event.getUserID() != userId) return false;
        } catch (Throwable e) {
            return false;
        }
        return true;
    }
}
