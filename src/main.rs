use actix_web::{get, App, HttpRequest, HttpResponse, HttpServer, Responder};

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    HttpServer::new(|| {
        App::new()
            .service(index)
            .service(fish)
    })
    .bind(("127.0.0.1", 8080))?
    .run()
    .await
}

#[get("/")]
async fn index() -> impl Responder {
    HttpResponse::Ok().body("Works")
}

#[get("/{amnt}")]
async fn fish(req: HttpRequest) -> impl Responder {
    let amnt = req.match_info().get("amnt").unwrap();
    let fishies = "<>< ".repeat(amnt.parse::<usize>().expect("Not a number"));
    HttpResponse::Ok().body(fishies)
}
