use lambda_runtime::{handler_fn};
use log::{info};
use serde::{Deserialize,Serialize};
use std::collections::HashMap;

#[derive(Clone,Deserialize)]
#[serde(rename_all = "PascalCase")]
struct Event {
    pub records: Vec<Record>,
}

#[derive(Clone,Deserialize)]
struct Record {
    pub cf: CloudFront,
}

#[derive(Clone,Deserialize)]
struct CloudFront {
    pub response: Response<()>,
}

#[derive(Clone, Deserialize, Serialize)]
struct Response<T> {
    headers: HashMap<String, String>,
    body: T,
}


#[tokio::main]
async fn main() -> Result<(), lambda_runtime::Error> {
    let func = handler_fn(handler);
    lambda_runtime::run(func).await?;

    Ok(())
}

async fn handler(event: Event, _ctx: lambda_runtime::Context) -> Result<Response<()>, lambda_runtime::Error> {
    info!("handling a request...");

    let response = event.records[0].cf.response.clone();
    // let headers = response.headers_mut();
    // headers.insert("x-frame-options", HeaderValue::from_static("DENY"));

    Ok(response)
}