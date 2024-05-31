package backend.lezaczek.HttpInterfaces;

import backend.lezaczek.Model.News;
import lombok.Getter;
import lombok.ToString;

import java.util.List;

@ToString
public class NewsResponse extends Response{
    @Getter
    private final List <News> news;

    public NewsResponse(List<News> news){
        super("ok");
        this.news = news;
    }
}
