module ApplicationHelper
    def default_meta_tags
    {
      site: '緑の掲示板',
      title: '育てている植物を観察日記として共有できるサービス',
      reverse: true,
      charset: 'utf-8',
      description: 'ご自宅の庭やベランダなどで育てている植物を観察日記として共有しよう。きっとあなたも育ててみたくなるかも。',
      keywords: '園芸,探求,知識,共有',
      canonical: 'https://midorino-keijiban.com/',
      separator: '|',
      og:{
        site_name: :site,
        title: :title,
        description: :description,
        type: 'website',
        url: 'https://midorino-keijiban.com/',
        image: image_url('ogp.jpg'),
        local: 'ja-JP'
      },
      twitter: {
        card: 'summary_large_image',
        image: image_url('ogp.jpg')
      }
    }
  end
end
