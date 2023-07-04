using Genie, Logging

Genie.Configuration.config!(
  server_port                     = 8000,
  # server_host                     = "127.0.0.1", # please change to private ipv4 if test with EC2 terminal
  server_host                     = "172.31.95.69",
  log_level                       = Logging.Info,
  log_to_file                     = false,
  server_handle_static_files      = true,
  path_build                      = "build",
  format_julia_builds             = true,
  format_html_output              = true,
  watch                           = true,
  cors_headers                    = Dict(
                                      "Access-Control-Allow-Origin" => "*",
                                      "Access-Control-Allow-Headers" => "Content-Type",
                                      "Access-Control-Allow-Methods" => "GET,POST")

)

ENV["JULIA_REVISE"] = "auto"