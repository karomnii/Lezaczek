package backend.lezaczek.Services;

import backend.lezaczek.Helpers.JwtTokenHelper;
import backend.lezaczek.Model.News;
import backend.lezaczek.Model.User;
import backend.lezaczek.Repositories.NewsRepository;
import backend.lezaczek.Repositories.UsersRepository;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Service
public class NewsService {
    private final NewsRepository newsRepository;

    private UsersRepository usersRepository;

    @Autowired
    JwtTokenHelper jwtTokenHelper;

    @Autowired
    private User currentUser;

    @Autowired
    public NewsService(NewsRepository newsRepository, UsersRepository usersRepository) {
        this.newsRepository = newsRepository;
        this.usersRepository = usersRepository;
    }

    public List<News> getNews(HttpServletRequest request) {
        return newsRepository.findAllByOrderByDateOfEventAscStartingTimeAsc();
    }

    public Optional<News> getNewsById(Long newsId, HttpServletRequest request){
        return newsRepository.findById(newsId);
    }

    public News addNews(News news, HttpServletRequest request){
        Optional<News> newsByName = newsRepository.findNewsByName(news.getName());
        if(newsByName.isPresent()){
            throw new RuntimeException("News already exists");
        }
        boolean isValid = isNewsValid(news);
        if(!isValid){
            throw new RuntimeException("Invalid news parameters");
        }
        //TODO: try to implement userValidation method
        Long userId;
        try {
            userId = jwtTokenHelper.extractUserId(request);
//            userId = 2L; //test value
        }
        catch (Throwable e){
            throw new RuntimeException("Authorization token is invalid");
        }
        User user = usersRepository.findUserByUserId(userId);
        if(user.getIsAdmin() == 0){
            throw new RuntimeException("You don't have permission to this resource");
        }
        news.setUserId(userId);
        news.setDateAdded(LocalDate.now());
        newsRepository.save(news);
        return news;
    }

    public void deleteOutdatedNews(Long newsId){
        newsRepository.deleteNewsByNewsId(newsId);
    }

    public void deleteNews(Long newsId, HttpServletRequest request) {
        Optional<News> newsOptional = newsRepository.findById(newsId);
        if(newsOptional.isPresent()){
            Long userId;
            try {
                userId = jwtTokenHelper.extractUserId(request);
//              userId = 2L; //test value
            }
            catch (Throwable e){
                throw new RuntimeException("Authorization token is invalid");
            }
            User user = usersRepository.findUserByUserId(userId);
            if(user.getIsAdmin() == 1){
                newsRepository.deleteById(newsId);
            }
            else{
                throw new RuntimeException("You don't have permission to this resource");
            }
        }
        else{
            throw new RuntimeException("News not found");
        }
    }

    @Transactional
    public News updateNews(News newData, HttpServletRequest request) {
        News news = newsRepository.findById(newData.getNewsId()).orElseThrow(() ->new RuntimeException("News doesn't exist"));
        Long userId;
        try {
            userId = jwtTokenHelper.extractUserId(request);
//            userId = 2L; //test value
        }
        catch (Throwable e){
            throw new RuntimeException("Authorization token is invalid");
        }
        User user = usersRepository.findUserByUserId(userId);
        if(user.getIsAdmin() == 0){
            throw new RuntimeException("You don't have permission to this resource");
        }
        if(!isNewsValid(newData)){
            throw new RuntimeException("Entered data is invalid");
        }
        news.setName(newData.getName());
        news.setDescription(newData.getDescription());
        news.setPlace(newData.getPlace());
        news.setDateOfEvent(newData.getDateOfEvent());
        news.setStartingTime(newData.getStartingTime());
        news.setEndingTime(newData.getEndingTime());
        newsRepository.save(news);
        return news;
    }

    boolean isNewsValid(News news){
        return !news.getName().isEmpty() && !news.getPlace().isEmpty()
                && news.getStartingTime().isBefore(news.getEndingTime());
    }

}