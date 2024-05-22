package backend.lezaczek.Controllers;

import org.springframework.beans.factory.annotation.Autowired;

import java.util.stream.Collector;
import java.util.stream.Collectors;

import org.json.JSONArray;
import org.json.JSONObject;
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
        System.out.println(eventService.getAllEvents().stream().map(event -> event.toString()).toArray()[0]);
        return eventService.getAllEvents().stream().map(event -> event.toString()).toArray();
        }
    
}
