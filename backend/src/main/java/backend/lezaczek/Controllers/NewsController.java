package backend.lezaczek.Controllers;

import backend.lezaczek.Helpers.JwtTokenHelper;
import backend.lezaczek.HttpInterfaces.ErrorResponse;
import backend.lezaczek.HttpInterfaces.NewsResponse;
import backend.lezaczek.HttpInterfaces.Response;
import backend.lezaczek.Model.News;
import backend.lezaczek.Services.NewsService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/news")
public class NewsController {
    @Autowired
    private final NewsService newsService;
    @Autowired
    JwtTokenHelper jwtTokenHelper;

    public NewsController(NewsService newsService) {
        this.newsService = newsService;
    }
    @GetMapping
    public List<News> getNews(HttpServletRequest request){
        return newsService.getNews(request);
    }

    @GetMapping( "/{newsId}")
    public ResponseEntity<?> getNewsById(@PathVariable("newsId") Long newsId,
                                         HttpServletRequest request) {
        Optional <News> newsOptional = newsService.getNewsById(newsId, request);
        if(newsOptional.isEmpty()){
            return ResponseEntity.badRequest().body(new ErrorResponse("News not found"));
        }
        return ResponseEntity.ok(new NewsResponse(List.of(newsOptional.get())));
    }

    @PostMapping
    public void createNews(@RequestBody News news, HttpServletRequest request){
        newsService.addNews(news, request);
    }

    @DeleteMapping(path = "{newsId}")
    public ResponseEntity<?> deleteNews(@PathVariable("newsId") Long newsId, HttpServletRequest request){
        try{
            newsService.deleteNews(newsId, request);
        }
        catch (RuntimeException e){
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
            newsService.updateNews(request,newsId, name, description, dateOfEvent, place, startingTime, endingTime);
        }
        catch (RuntimeException e){
            return ResponseEntity.badRequest().body(new ErrorResponse(e.getMessage()));
        }
        return ResponseEntity.ok(new Response("News has been updated"));
    }
}