resource "github_repository" "ex_r" {
  name             = "github-terraform-task-io-shakleina"
  default_branch   = "develop"
  allow_rebase_merge = false
  allow_squash_merge = false
  allow_merge_commit = true

  collaborators {
    username = "softservedata"
    permission = "push"
  }
}
