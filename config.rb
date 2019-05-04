require 'slim'
require 'gqli'

SPACE_ID = '1fe13xet117f'.freeze
CTF_ACCESS_TOKEN = '0f7e74f58043fe4c03d4bcdf03cc8a95b917047aafbf1054e8d73d17acc769e9'.freeze
CONTENTFUL_GQL = GQLi::Contentful.create(SPACE_ID, CTF_ACCESS_TOKEN)

GH_ACCESS_TOKEN = ENV.fetch('GITHUB_OAUTH_TOKEN', '<GH_TOKEN>')
GITHUB_GQL = GQLi::Github.create(GH_ACCESS_TOKEN)

helpers do
  def repositories
    CONTENTFUL_GQL.execute(
      GQLi::DSL.query {
        repoCollection {
          items {
            name
            owner
          }
        }
      }
    ).data.repoCollection.items
  end

  def repository_details(owner, name)
    GITHUB_GQL.execute(
      GQLi::DSL.query {
        repository(owner: owner, name: name) {
          description
          forkCount
          stargazers {
            totalCount
          }
          url
        }
      }
    ).data.repository
  end
end

Slim::Engine.set_default_options :pretty => true
set :slim, :layout_engine => :slim

set :css_dir, 'stylesheets'

set :js_dir, 'javascripts'

set :images_dir, 'images'

configure :build do
end
