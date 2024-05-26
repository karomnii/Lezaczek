package backend.lezaczek.Controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import backend.lezaczek.HttpInterfaces.Response;
import backend.lezaczek.Model.Event;
import backend.lezaczek.Services.EventService;
import jakarta.servlet.http.HttpServletRequest;
import backend.lezaczek.Helpers.JwtTokenHelper;

import java.sql.Date;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/events")
public class EventController {

    private final int userId = 1;  // Placeholder value
    @Autowired
    private EventService eventService;
    @Autowired
    JwtTokenHelper jwtTokenHelper;
    @GetMapping
    public List<Event> getAllEvents() {
        return eventService.getAllEvents();
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getEventById(@PathVariable Long id, HttpServletRequest request) {
        Event event = eventService.getEventById(id).get();
        if (!eventService.eventMatchesUser(event, request)) {
            return ResponseEntity.status(403).build();  // 403 Forbidden
        }
        return ResponseEntity.ok(new Response(Map.of("eventData",event)));
    }

    @GetMapping("/date/{selectedDate}")
    public ResponseEntity<?> getEventsByDate(@PathVariable String selectedDate, HttpServletRequest request) { // selectedDate format: "yyyy-MM-dd"
        Date date;
        try {
            date=Date.valueOf(selectedDate);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.status(403).build();  // 403 Forbidden
        }
        List<Event> eventsList = eventService.getEventsByDate(date, request);
        return ResponseEntity.ok(new Response(Map.of("events",eventsList))); //check if magicly works

    }

    @PostMapping
    public Event createEvent(@RequestBody Event event) {
        event.setUserID(userId);  // Set the user ID to the placeholder value
        return eventService.createEvent(event);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Event> updateEvent(@PathVariable Long id, @RequestBody Event eventDetails) {
        try {
            Event updatedEvent = eventService.updateEvent(id, eventDetails, userId);
            return ResponseEntity.ok(updatedEvent);
        } catch (RuntimeException e) {
            return ResponseEntity.status(403).body(null);  // 403 Forbidden
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteEvent(@PathVariable Long id) {
        try {
            eventService.deleteEvent(id, userId);
            return ResponseEntity.noContent().build();
        } catch (RuntimeException e) {
            return ResponseEntity.status(403).build();  // 403 Forbidden
        }
    }
}
