package backend.lezaczek.Controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import backend.lezaczek.HttpInterfaces.EventResponse;
import backend.lezaczek.HttpInterfaces.Response;
import backend.lezaczek.Model.Event;
import backend.lezaczek.Services.EventService;
import jakarta.servlet.http.HttpServletRequest;
import backend.lezaczek.Helpers.JwtTokenHelper;

import java.sql.Date;
import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/events")
public class EventController {

    @Autowired
    private EventService eventService;

    @Autowired
    JwtTokenHelper jwtTokenHelper;

    // not used right now
    // @GetMapping
    // public List<Event> getAllEvents() {
    //     return eventService.getAllEvents();
    // }

    @GetMapping("/{id}")
    public ResponseEntity<?> getEventById(@PathVariable Long id, HttpServletRequest request) {
        Optional<Event> eventOpt = eventService.getEventById(id);
        if (eventOpt.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
        }
        Event event = eventOpt.get();
        if (!eventService.eventMatchesUser(event, request)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();  // 403 Forbidden
        }
        return ResponseEntity.ok(new EventResponse(List.of(event)));
    }

    @GetMapping("/date/{selectedDate}")
    public ResponseEntity<?> getEventsByDate(@PathVariable String selectedDate, HttpServletRequest request) { // selectedDate format: "yyyy-MM-dd"
        Date date;
        try {
            date = Date.valueOf(selectedDate);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).build();  // 400 Bad Request
        }
        List<Event> eventsList = eventService.getEventsByDate(date, request);
        return ResponseEntity.ok(new EventResponse(eventsList));
    }
    //todo: test and fix error handling
    @PutMapping
    public ResponseEntity<?> createEvent(@RequestBody Event event, HttpServletRequest request) {
        // Long userId = Long.parseLong(jwtTokenHelper.extractClaims(request));
        Long userId = 1L;
        event.setUserID(userId.intValue());
        Event createdEvent = eventService.createEvent(event);
        if (createdEvent == null) {
            System.out.println("Failed to create event");
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).build();  // 400 Bad Request
        }
        return ResponseEntity.status(HttpStatus.CREATED).body(new EventResponse(List.of(createdEvent)));
    }
    //todo: test and fix error handling
    @PostMapping
    public ResponseEntity<?> updateEvent(@RequestBody Event event, HttpServletRequest request) {
        if (!eventService.eventMatchesUser(event, request)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();  // 403 Forbidden
        }
        try {
            Event updatedEvent = eventService.updateEvent(event);
            return ResponseEntity.ok(new EventResponse(List.of(updatedEvent)));
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(null);  // 403 Forbidden
        }
    }
    //todo: test and fix error handling
    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteEvent(@PathVariable Long id, HttpServletRequest request) {
        try {
            eventService.deleteEvent(id, request);
        } catch (RuntimeException e) {
            if (e.getMessage().equals("Event not found with id " + id)){
                return ResponseEntity.status(HttpStatus.NOT_FOUND).build();  // 404 Not Found
            } else{
                return ResponseEntity.status(HttpStatus.FORBIDDEN).build();  // 403 Forbidden
            }
        }
        return ResponseEntity.ok(new Response("ok"));
    }
}
