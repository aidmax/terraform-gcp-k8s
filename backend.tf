terraform {
 backend "gcs" {
   bucket  = "micro-citadel-216209"
   prefix  = "terraform/state"
   project = "micro-citadel-216209"
 }
}
