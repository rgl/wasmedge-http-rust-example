use askama::Template;
use std::net::SocketAddr;
use warp::Filter;

mod meta;

#[derive(Template)]
#[template(path = "index.html")]
struct IndexTemplate<'a> {
    source_url: &'a str,
    version: &'a str,
    revision: &'a str,
    author_name: &'a str,
    author_url: &'a str,
}

#[tokio::main(flavor = "current_thread")]
async fn main() {
    println!("starting service {}+{}", meta::VERSION, meta::REVISION);
    let index = warp::path!().map(|| {
        let template = IndexTemplate {
            source_url: meta::SOURCE_URL,
            version: meta::VERSION,
            revision: meta::REVISION,
            author_name: meta::AUTHOR_NAME,
            author_url: meta::AUTHOR_URL,
        };
        let html = template.render().unwrap();
        warp::reply::html(html)
    });
    let addr: SocketAddr = "0.0.0.0:8080".parse().expect("Invalid listen address");
    println!("listening at http://{}", addr);
    warp::serve(index).run(addr).await
}
