class User < ApplicationRecord

    has_secure_password
    
    has_many :work_experiences, dependent: :destroy
    has_many :addresses, dependent: :destroy
    has_many :educations, dependent: :destroy
    has_many :projects, dependent: :destroy
    has_many :skills, dependent: :destroy
    has_many :websites, dependent: :destroy

    # Active Storage related
    has_one_attached :profile_image
    has_one_attached :resume


    validates :email, uniqueness: true
    validates :user_slug, uniqueness: true

    def user_obj 
        {
            'user': {
                'id': self.id,
                'user_slug': self.user_slug,
                # 'username': self.username,
                'first_name': self.first_name,
                'last_name': self.last_name,
                'phone': self.phone,
                'email': self.email,
                'profile_image': self.profile_image_url,
                'resume': self.resume_url
            },
            'work_experiences': self.work_experiences.map do |work_exp|
                {
                    'id': work_exp.id,
                    'company': work_exp.company,
                    'title': work_exp.title,
                    'start': work_exp.start,
                    'end': work_exp.end,
                    'city': work_exp.city,
                    'state': work_exp.state,
                    'description': work_exp.description
                    
                }
            end,
            'skills': self.skills.map do |skill|
                {
                    'id': skill.id,
                    'name': skill.name,
                    'proficiency': skill.proficiency
                }
            end,
            'educations': self.educations.map do |edu|
                {
                    'id': edu.id,
                    'university': edu.university,
                    'degree': edu.degree,
                    'concentration': edu.concentration,
                    'start': edu.start,
                    'end': edu.end
                }
            end,
            'projects': self.projects.map do |proj|
                {
                    'id': proj.id,
                    'title': proj.title,
                    'description': proj.description,
                    'link': proj.link,
                }
            end,
            'websites': self.websites.map do |web|
                {
                    'id': web.id,
                    'link': web.link
                }
            end,
            'addresses': self.addresses.map do |add|
                {
                    'id': add.id,
                    'street1': add.street1,
                    'street2': add.street2,
                    'city': add.city,
                    'state': add.state,
                    'zip': add.zip,
                    'country': add.country
                }
            end
        }
    end

    # def slug_it # for generating website
    #     "#{first_name}-#{last_name}".downcase
    # end

    # Active Storage

    def profile_image_url
        rails_blob_path(self.profile_image, only_path: true) if self.profile_image.attached?
    end

    def resume_url
        rails_blob_path(self.resume, only_path: true) if self.resume.attached?
    end
end
