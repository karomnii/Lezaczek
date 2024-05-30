package backend.lezaczek.Controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import backend.lezaczek.HttpInterfaces.ErrorResponse;
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

    @GetMapping("/{id}")
    public ResponseEntity<?> getEventById(@PathVariable Long id, HttpServletRequest request) {
        Optional<Event> eventOpt = eventService.getEventById(id);
        if (eventOpt.isEmpty()) {
            return ResponseEntity.badRequest().body(new ErrorResponse("Event not found"));
        }
        Event event = eventOpt.get();
        if (!eventService.eventMatchesUser(event, request)) {
            return ResponseEntity.badRequest().body(new ErrorResponse("Event does not belong to user"));
        }
        return ResponseEntity.ok(new EventResponse(List.of(event)));
    }

    @GetMapping("/date/{selectedDate}")
    public ResponseEntity<?> getEventsByDate(@PathVariable String selectedDate, HttpServletRequest request) { // selectedDate format: "yyyy-MM-dd"
        Date date;
        try {
            date = Date.valueOf(selectedDate);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(new ErrorResponse("Invalid date format"));
        }
        try {
            List<Event> eventsList = eventService.getEventsByDate(date, request);
            return ResponseEntity.ok(new EventResponse(eventsList));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(new ErrorResponse("Invalid authorization token"));
        }
    }
    @PutMapping
    public ResponseEntity<?> createEvent(@RequestBody Event event, HttpServletRequest request) {
        try {
            Long userId = Long.parseLong(jwtTokenHelper.extractUserId(request));
            event.setUserID(userId.intValue());
        } catch (Throwable e) {
            return ResponseEntity.badRequest().body(new ErrorResponse("Invalid authorization token"));
        }
        try {
            Event createdEvent = eventService.createEvent(event);
            if (createdEvent == null) {
                return ResponseEntity.badRequest().body(new ErrorResponse("Invalid event data"));
            }
            return ResponseEntity.ok(new EventResponse(List.of(createdEvent)));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(new ErrorResponse(e.getMessage()));
        }
    }
    @PostMapping
    public ResponseEntity<?> updateEvent(@RequestBody Event event, HttpServletRequest request) {
        if (!eventService.eventMatchesUser(event, request)) {
            return ResponseEntity.badRequest().body(new ErrorResponse("Event does not belong to user"));
        }
        try {
            Event updatedEvent = eventService.updateEvent(event);
            return ResponseEntity.ok(new EventResponse(List.of(updatedEvent)));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(new ErrorResponse(e.getMessage()));
        }
    }
    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteEvent(@PathVariable Long id, HttpServletRequest request) {
        try {
            eventService.deleteEvent(id, request);
        } catch (RuntimeException e) {
            if (e.getMessage().equals("Event not found")){
                return ResponseEntity.badRequest().body(new ErrorResponse(e.getMessage()));
            } else{
                return ResponseEntity.badRequest().body(new ErrorResponse(e.getMessage()));
            }
        }
        return ResponseEntity.ok(new Response("ok"));
    }
}
