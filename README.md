# Coding Challenge - *git a grep!* <sup name="a1">[1](#f1)</sup>

*Get a grip on GitHub with this quick grep tool.*

**git-a-grep** is a basic GitHub repository search app for iOS.

Created by: **Tejen Patel**.

Time spent: **X** hours spent in total

## User Stories

The following **required** functionality is complete:

* [X] On initial launch, fetch the initial set of repos that contain the string `graphql`
* [X] Each repository shows its own name, creator name, profile photo, and number of stars
* [X] Infinite scrolling: the next set of repositories are fetched upon scrolling to the bottom of the list

The following **additional** features are implemented:
* [X] UI animations
* [X] Loading activity indicator
* [X] Ability to search for custom queries other than `graphql`
* [X] App Icons for every iPhone model and size.
* [X] Large scroll-sensitive animated Title above View Controller
* [ ] A details screen upon tapping on a Repository (not implemented)
* [ ] What else could ya do?

## Getting Started

1. Clone the `main` branch or the `mvvm` branch
1. Run `pod install`
1. In the `Source ➡️ Networking ➡️ GitHubAPIKey.txt` file, paste in your [Personal Access Token](https://docs.github.com/en/github/authenticating-to-github/keeping-your-account-and-data-secure/creating-a-personal-access-token) from GitHub
1. Run the app! 🚀 *It may take a minute for Xcode complete the Apollo Build Scripts (probing and caching GitHub's public API schema, and auto-generating a schema.json and API.swift file)*

## Video Walkthrough 

#### Here's a walkthrough of implemented user stories on an *iPhone*:
<img src='https://i.imgur.com/bOYzQDa.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIFs created with [LiceCap](http://www.cockos.com/licecap/).


## Notes

I have no experience in the MVVM design pattern, so I'm excited that this project is my first foray into that! I decided to first create the entire project in the way I'm most comfortable with, and then went ahead to make changes to convert the project to a more MVVM approach, by refactoring and creating some new View Model classes.

:warning: I then pushed this new "converted" version of the project to a new [`mvvm`](https://github.com/tejen/peek-ios-coding-challenge/commits/mvvm) branch here, but the original version is still in my `main` branch.

I'm not too confident whether I've performed followed MVVM correctly according to its principles, since I've never seen how iOS should be done in MVVM. I think I'm still struggling to understand the fundamentals of MVVM. Particularly, the code separation between the main View Controller and its View Model was my biggest question here... how much of the code should remain in the View Controller, and how much of it should be moved into the a View Model Swift file for it?

I followed some online tutorials and YouTube videos on how to transition from an MVC mindset to MVVM, although all the examples I found were really different from each other haha. I think my approach to converting this app to MVVM (in [the `mvvm` branch](https://github.com/tejen/peek-ios-coding-challenge/commits/mvvm) here) made the code seem super convoluted. Hopefully I'm wrong, and this is just how it's supposed to be 😅 either way, I think it was an enjoyable experience to finally get into it and try something new!

What I did appreciate was how MVVM code is super compartmentalized. The Controller, View Model, and View itself are pretty oblivious to each other and to the entire Model/data coming in from the GitHub API. Because of this de-coupling and less tight integration between them all, I definitely realized how MVVM would help in especially large teams, where there would be different people developing each of these classes.

It'll be good to get more experience in MVVM in the next few weeks, learning more about what it promises to offer, and developing that muscle-memory as to what code goes in which class for MVVM versus MVC!

For the file/folder organization and project structure, I looked at some Xcode projects that Peek has public on their GitHub organization page, and tried to model it off of that. Within Xcode projects, I see that "Source" folder that's commonly used across Peek's iOS engineering team, and I made one too to keep all of my actual code files in! 🧐📚

In terms of GraphQL, this was actually my first foray into that too, and I realized that GraphQL is super cool! There's no "endpoints" per say, like a REST API... I'm lowkey designing my own endpoints here, and literally telling the server exactly what I want! That flexibility was mind-blowing. Plus, Apollo makes it a cinch to work with GraphQL. After I got through the hard part of [allowing Apollo to auto-download the GitHub GraphQL API v4 Schema](https://github.com/tejen/peek-ios-coding-challenge/commit/6936aa6078116ec8a43968359b040a3fb4bc769f), it generated an API.swift file like magic! I was fascinated with how it effectively created my entire Model class, complete with all the fields that the GitHub API has to offer, and even the right type-safety for each of those properties, based on the API's public schema 🤩 I'm definitely looking forward to working more with GraphQL in the future.

Excited to hear back from Peek! Looking forward to the opportunity with all hope. ✨

## License

    Copyright ©2021 Tejen Hasmukh Patel

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
    

## Footnotes

  <b id="f1">[1]</b> This README is based directly off of an [open-source template](https://courses.codepath.com/snippets/intro_to_ios/readme_templates/prework_readme.md) created by CodePath.org. [↩](#a1)
  
