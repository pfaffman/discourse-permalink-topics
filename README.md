# Permalink Topics

PermalinkTopics will automatically create a permalink for each topic created in a category when a Permalink Prefix (category setting) is defined.

For example, if the Permalink Prefix for the "Very Important Category" is "important" then each topic created in the category will have a permalink `/important/<topic_id>` that will redirect to the category.

The displayed URL for the topic will not be changed. This just allows for a slighly prettier URL to be publicly shared.

## Installation

Follow [Install a Plugin](https://meta.discourse.org/t/install-a-plugin/19157)
how-to from the official Discourse Meta, using `git clone https://github.com/pfaffman/topic-default-tag.git`
as the plugin command.

## Usage

To use, enable the plugin with the `permalink_topics_enabled` site setting and add a permalink prefix in the category settings.

## Feedback

If you have issues or suggestions for the plugin, please bring them up on
[support.literatecomputing.com](https://support.literatecomputing.com/t/permalink-topics-plugin/538).
