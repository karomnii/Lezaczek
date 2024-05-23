package backend.lezaczek.Controllers;

import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import backend.lezaczek.Services.EventService;

@RestController
@RequestMapping("/events")
public class EventsController {
    @Autowired
    private EventService eventService;
    @GetMapping(produces = "application/json", path = "/all")
    public Object getAllEvents(){
        return eventService.getAllEvents().toString();
        }
    
}
