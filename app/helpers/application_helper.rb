module ApplicationHelper
    def default_meta_tags
    {
      site: "みどりのへや",
      title: "みどりのへや",
      reverse: true,
      charset: "utf-8",
      description: "観葉植物を飾ってみよう。",
      keywords: "植物,共有",
      canonical: "https://midorino-heya.onrender.com",
      separator: "|",
      og: {
        site_name: :site,
        title: :title,
        description: :description,
        type: "website",
        url: "https://midorino-heya.onrender.com",
        image: image_url("ogp.png"),
        local: "ja-JP"
      },
      twitter: {
        card: "summary_large_image",
        image: image_url("ogp.png")
      }
    }
  end
end
