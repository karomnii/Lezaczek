package backend.lezaczek.Controllers;

import backend.lezaczek.HttpInterfaces.ErrorResponse;
import backend.lezaczek.HttpInterfaces.NewsResponse;
import backend.lezaczek.HttpInterfaces.Response;
import backend.lezaczek.Model.News;
import backend.lezaczek.Services.NewsService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cglib.core.Local;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.sql.Time;
import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.Month;
import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/news")
public class NewsController {
    @Autowired
    private final NewsService newsService;

    public NewsController(NewsService newsService) {
        this.newsService = newsService;
    }
    @GetMapping
    public List<News> getNews(){
        return newsService.getNews();
    }

    @GetMapping("{newsId}")
    public ResponseEntity<?> getNewsById(@PathVariable("newsId") Long newsId, HttpServletRequest request) {
        Optional <News> newsOptional = newsService.getNewsById(newsId);
        if(newsOptional.isEmpty()){
            return ResponseEntity.badRequest().body(new ErrorResponse("News not found"));
        }
        return ResponseEntity.ok(new NewsResponse(List.of(newsOptional.get())));
    }

    @PostMapping
    public void createNews(@RequestBody News news){
        newsService.addNews(news);
    }

    @DeleteMapping(path = "{newsId}")
    public ResponseEntity<?> deleteNews(@PathVariable("newsId") Long newsId, HttpServletRequest request){
        try{
            newsService.deleteNews(newsId, request);
        }
        catch (RuntimeException e){
            if(e.getMessage().equals("News not found")){
                return ResponseEntity.badRequest().body(new ErrorResponse(e.getMessage()));
            }
            return ResponseEntity.badRequest().body(new ErrorResponse(e.getMessage()));
        }
        return ResponseEntity.ok(new Response("ok"));
    }

    @PutMapping(path = "{newsId}")
    public ResponseEntity<?> updateNews(@PathVariable("newsId") Long newsId,
                           @RequestParam(required = false) String name,
                           @RequestParam(required = false) String description,
                           @RequestParam(required = false) String dateOfEvent,
                           @RequestParam(required = false) String place,
                           @RequestParam(required = false) String startingTime,
                           @RequestParam(required = false) String endingTime,
                            HttpServletRequest request){
        try {
            News temporaryNews = newsService.updateNews(newsId, name, description, dateOfEvent, place, startingTime, endingTime);
        }
        catch (RuntimeException e){
            return ResponseEntity.badRequest().body(new ErrorResponse(e.getMessage()));
        }
        return ResponseEntity.ok(new Response("News has been updated"));
    }
}