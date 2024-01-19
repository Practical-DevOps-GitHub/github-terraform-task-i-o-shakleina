provider "github" {
  token =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
}

resource "github_repository" "ex_r" {
  name             = "github-terraform-task-io-shakleina"
  description      = "tefrraform"
  auto_init        = true
  default_branch   = "develop"
  allow_rebase_merge = false
  allow_squash_merge = false
  allow_merge_commit = true

  collaborators {
    username = "softservedata"
    permission = "push"
  }

  branch_protection_rule {
    pattern             = "main"
    requires_approving_reviews = true
    required_approving_review_count = 1
    enforce_admins      = true
    requires_code_owner_reviews = true
  }

  branch_protection_rule {
    pattern             = "develop"
    requires_approving_reviews = true
    required_approving_review_count = 2
    enforce_admins      = true
  }
}

resource "github_branch_protection" "main_branch_protection" {
  repository = github_repository.ex_r.name
  branch     = "main"

  required_pull_request_reviews {
    dismiss_stale_reviews          = true
    require_code_owner_reviews     = true
    required_approving_review_count = 1
  }
}

resource "github_branch_protection" "develop_branch_protection" {
  repository = github_repository.ex_r.name
  branch     = "develop"

  required_pull_request_reviews {
    dismiss_stale_reviews          = true
    require_code_owner_reviews     = false
    required_approving_review_count = 2
  }
}

resource "github_codeowners" "codeowners" {
  repository = github_repository.ex_r.name
  owners     = ["softservedata"]
}

resource "github_actions_secret" "pat_secret" {
  repository = github_repository.ex_r.name
  secret_name = "PAT"
  plaintext_value = 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
}

resource "github_actions_workflow" "notification_workflow" {
  name     = "Notify on Pull Request Creation"
  repository = github_repository.ex_r.name
  on       = "pull_request"
  
  resolves = ["notify_discord"]

  trigger {
    event = "pull_request"
  }

  action {
    name   = "notify_discord"
    uses   = "softservedata/discord-notification-action@v1"
    secrets = {
      DISCORD_WEBHOOK_URL = https://discordapp.com/api/webhooks/1192581811600117940/6Fa9uaICP6PaW28N08vdQeVrd6Bd0SW1ySBGgetfK-hEPAjoIJPRfwbXPz-ASTiIW_8-
    }
  }
}
