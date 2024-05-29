package backend.lezaczek.Controllers;

import backend.lezaczek.Model.News;
import backend.lezaczek.Services.NewsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cglib.core.Local;
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

    @PostMapping
    public void createNews(@RequestBody News news){
        newsService.addNews(news);
    }

    @DeleteMapping(path = "{newsId}")
    public void deleteNews(@PathVariable("newsId") Long newsId){
        newsService.deleteNews(newsId);
    }

    @PutMapping(path = "{newsId}")
    public void updateNews(@PathVariable("newsId") Long newsId,
                           @RequestParam(required = false) String name,
                           @RequestParam(required = false) String description,
                           @RequestParam(required = false) LocalDate dateOfEvent,
                           @RequestParam(required = false) String place,
                           @RequestParam(required = false) LocalTime startingTime,
                           @RequestParam(required = false) LocalTime endingTime){
        newsService.updateNews(newsId, name, description, dateOfEvent, place, startingTime, endingTime);
    }
}