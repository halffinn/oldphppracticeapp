# TEST ENVIRONMENT OVERRIDES
if Rails.env.test?
  ENV['S3_BUCKET'] == 'squarestays-img-test'
  ENV['COOKIE_STORE_KEY'] == '_SquareStaysTestBackEnd_session'
  ENV['REDISTOGO_URL'] == 'redis://mopx:aaf3ce5564ab359b8695223b53a50002@stingfish.redistogo.com:9181'
end

# SET VARIABLES, DEVELOPMENT FALLBACKS
S3_ACCESS_KEY_ID =      ENV['S3_ACCESS_KEY_ID']       || 'AKIAICSWWKMXN4NP7FIQ'
S3_SECRET_ACCESS_KEY =  ENV['S3_SECRET_ACCESS_KEY']   || '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'
S3_BUCKET =             ENV['S3_BUCKET']              || 'squarestays-img-dev'
FB_APP_ID =             ENV['FB_APP_ID']              || '221413484589066'
FB_APP_SECRET =         ENV['FB_APP_SECRET']          || '719daf903365b4bab445a2ef5c54c2ea'
FRONTEND_PATH =         ENV['FRONTEND_PATH']          || 'http://localhost:5000'
SECRET_TOKEN =          ENV['SECRET_TOKEN']           || '4fafcf33a55a5b7d6cd2be869e9f450b65ea004e421c05b459ebb2643e7a6b3201d5f1e2da0ce7310102c7d48368b0d100087f73545fd14aff0de8050f818a61'
COOKIE_STORE_KEY =      ENV['COOKIE_STORE_KEY']       || '_SquareStaysDevelopmentBackEnd_session'
REDISTOGO_URL =         ENV['REDISTOGO_URL']          || 'redis://127.0.0.1:6379'
MAILER_SENDER =         ENV['MAILER_SENDER']          || 'SquareStays.com <noreply@squarestays.com>'
PEPPER_TOKEN =          ENV['PEPPER_TOKEN']           || 'Z8TxukxAnyxxjRgs6jSB3Y3v4AzHjFvPFxpaENsJCnrkDUuYgTcaWywccE3CA8Gdgs6jSB3Y3v4AzHjFvPFxpaENsJCnrkDUWywccE3CA8Gdgs6jSB3YAnyxxjRgs6jS'