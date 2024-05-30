package backend.lezaczek.Services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import backend.lezaczek.Helpers.JwtTokenHelper;
import backend.lezaczek.Model.Event;
import backend.lezaczek.Model.User;
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

    @Autowired
    private User currentUser;

    public List<Event> getAllEvents() {
        return eventsRepository.findAll();
    }

    public Optional<Event> getEventById(Long id) {
        return eventsRepository.findById(id);
    }

    public List<Event> getEventsByDate(Date selectedDate, HttpServletRequest request) {
        try {
            // Long userId = 1L; // hardcoded for testing
            Long userId = currentUser.getUserId();
            return eventsRepository.findByDateUserId(selectedDate, userId.intValue());
        } catch (Throwable e) {
            throw new RuntimeException("Authorization token invalid");
        }
    }

    public Event createEvent(Event event) {
        validateEvent(event);
        return eventsRepository.save(event);
    }

    public Event updateEvent(Event eventDetails) {
        Optional<Event> eventOptional = eventsRepository.findById(Long.valueOf(eventDetails.getEventId()));
        if (eventOptional.isPresent()) {
            Event event = eventOptional.get();
            validateEvent(eventDetails);
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
                Long userId = currentUser.getUserId();
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

    public boolean eventMatchesUser(Event event, HttpServletRequest request) {
        try {
            // Long userId = 1L; // hardcoded for testing
            Long userId = currentUser.getUserId();
            if (event.getUserID() != userId) return false;
        } catch (Throwable e) {
            return false;
        }
        return true;
    }

    public boolean eventIdMatchesUser(Long eventId, HttpServletRequest request) {
        Optional<Event> eventOpt = eventsRepository.findById(eventId);
        if (eventOpt.isEmpty()) return false;
        Event event = eventOpt.get();
        try {
            // Long userId = 1L; // hardcoded for testing
            Long userId = currentUser.getUserId();
            if (event.getUserID() != userId) return false;
        } catch (Throwable e) {
            return false;
        }
        return true;
    }

    public void validateEvent(Event event) {
        if (event.getName() == null || event.getName().isEmpty()) {
            throw new RuntimeException("Event name cannot be empty");
        }
        if (event.getDateStart() == null) {
            throw new RuntimeException("Event start date cannot be empty");
        }
        if (event.getDateEnd() == null) {
            throw new RuntimeException("Event end date cannot be empty");
        }
        if (event.getStartingTime() == null) {
            throw new RuntimeException("Event start time cannot be empty");
        }
        if (event.getEndingTime() == null) {
            throw new RuntimeException("Event end time cannot be empty");
        }
        if (event.getDateStart().after(event.getDateEnd())) {
            throw new RuntimeException("Event start date cannot be after end date");
        }
        if (event.getStartingTime().after(event.getEndingTime())) {
            throw new RuntimeException("Event start time cannot be after end time");
        }
        switch (event.getEventType()) {
            case SINGLE:
                if (!event.getDateStart().equals(event.getDateEnd())) {
                    throw new RuntimeException("Single event must have the same start and end date");
                }
                break;
            case DAILY:
                if (event.getDateStart().equals(event.getDateEnd())) {
                    throw new RuntimeException("Daily event must have different start and end date");
                }
                break;
            case WEEKLY:
                if (event.getDateStart().equals(event.getDateEnd())) {
                    throw new RuntimeException("Weekly event must have different start and end date");
                }
                if (event.getDateStart().toLocalDate().plusDays(7).isAfter(event.getDateEnd().toLocalDate())) {
                    throw new RuntimeException("Weekly event must last at least 7 days");
                }
                break;
            default:
                throw new RuntimeException("Invalid event type");
        }
    }
}
