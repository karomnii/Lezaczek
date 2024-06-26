package backend.lezaczek.Controllers;

import backend.lezaczek.Helpers.JwtTokenHelper;
import backend.lezaczek.HttpInterfaces.ErrorResponse;
import backend.lezaczek.HttpInterfaces.NewsResponse;
import backend.lezaczek.HttpInterfaces.Response;
import backend.lezaczek.Model.Event;
import backend.lezaczek.Model.News;
import backend.lezaczek.Services.NewsService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/news")
public class NewsController {
    private final NewsService newsService;

    @Autowired
    JwtTokenHelper jwtTokenHelper;

    @Autowired
    public NewsController(NewsService newsService) {
        this.newsService = newsService;
    }
    @GetMapping
    public ResponseEntity<?> getNews(){
        try {
            List<News> news = newsService.getNews();
            return ResponseEntity.ok(new NewsResponse(news));
        }
        catch (RuntimeException e){
            return ResponseEntity.badRequest().body(new ErrorResponse(e.getMessage()));
        }
    }

    @GetMapping( "{newsId}")
    public ResponseEntity<?> getNewsById(@PathVariable("newsId") Long newsId) {
        try{
            Optional <News> newsOptional = newsService.getNewsById(newsId);
            if(newsOptional.isEmpty()){
                return ResponseEntity.badRequest().body(new ErrorResponse("News not found"));
            }
            return ResponseEntity.ok(new NewsResponse(List.of(newsOptional.get())));
        }
        catch (RuntimeException e){
            return ResponseEntity.badRequest().body(new ErrorResponse(e.getMessage()));
        }
    }

    @PostMapping
    public ResponseEntity<?> createNews(@RequestBody News news, HttpServletRequest request){
        try{
            return ResponseEntity.ok(new NewsResponse(List.of(newsService.addNews(news, request))));
        }
        catch (RuntimeException e){
            return ResponseEntity.badRequest().body(new ErrorResponse(e.getMessage()));
        }
    }

    @DeleteMapping(path = "{newsId}")
    public ResponseEntity<?> deleteNews(@PathVariable("newsId") Long newsId, HttpServletRequest request){
        try{
            newsService.deleteNews(newsId, request);
            return ResponseEntity.ok(new Response("News has been deleted"));
        }
        catch (RuntimeException e){
            return ResponseEntity.badRequest().body(new ErrorResponse(e.getMessage()));
        }
    }

    @Transactional
    @DeleteMapping(path = "outdated/{newsId}")
    public void deleteOutdatedNews(@PathVariable("newsId") Long newsId){
        newsService.deleteOutdatedNews(newsId);
    }

    @PutMapping
    public ResponseEntity<?> updateNews(@RequestBody News news, HttpServletRequest request){
        try {
            News updatedNews = newsService.updateNews(news, request);
            return ResponseEntity.ok(new NewsResponse(List.of(updatedNews)));
        }
        catch (RuntimeException e){
            return ResponseEntity.badRequest().body(new ErrorResponse(e.getMessage()));
        }
    }
}
